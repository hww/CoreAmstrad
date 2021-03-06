package jemu.system.cpc;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import jemu.core.device.floppy.*;

/**
 * Provides a CPC Magic DSK Image, connected to a folder.
 * 
 * Patches :
 * CPC.java : fdc.getDrive(1).setDisc(Drive.BOTH_HEADS,new MagicCPCDiscImage());
 * UPD765A.java : writeSectorByte() : drive.notifyWriteSectorByte((byte)data, params[1], params[2], params[3], params[4]);
 * UPD765A.java : readSectorByte()  : drive.notifyReadSectorByte(params[1], params[2], params[3], params[4]);
 * 
 * 
 * Test sequences :
 * 
 * |b
 * cat
 * 10 print"hello
 * save"hello
 * save"pic",b,&c000,&4000
 * save"big",b,&8000,&8000
 * run"hello
 * |era,"hello.bas"
 * |ren,"pic2","pic"
 *
 * save"file",p => protected file, with '*' in cat
 * 
 */
public class MagicCPCDiscImage extends DiscImage {
	
	String path="D:\\Users\\frup64427\\Desktop\\mecasharkV0\\jemu-code-52\\JEMU\\magic";
//	String path = "C:\\workspaceLWJGL\\JEMU_CPC\\magic";

	int[][][][] ids;
	byte[][][][] sectors;
	int lastCylinder = 79;
	int headMask = 1;

	

	/** Creates a new instance of CPCDiscImage */
	public MagicCPCDiscImage() {
		super("MagicCPCDiscImage");
		createSectorStructure();
		listDir();
	}

	public static final int SECTS = 9;
	public static final int CYLS = 40; // x28
	public static final int HEADS = 1;

	private void createSectorStructure() {
		ids = new int[2][80][0][];
		sectors = new byte[2][80][][];
		for (int cyl = 0; cyl < CYLS; cyl++) {
			for (int head = 0; head < HEADS; head++) {

				ids[head][cyl] = new int[SECTS][4];
				sectors[head][cyl] = new byte[SECTS][];
				for (int sect = 0; sect < SECTS; sect++) {
					int[] sectId = ids[head][cyl][sect];
					sectId[0] = cyl; // C
					sectId[1] = 0; // H
					sectId[2] = 0xC1 + sect; // R
					sectId[3] = 0x02; // N
					int size = sectorSize(sectId[3]);
					byte[] sectData = sectors[head][cyl][sect] = new byte[size];
					for (int i = 0; i < size; i++)
						sectData[i] = (byte) 0xe5;
				}
			}
		}
	}
	private void resetSectorContent() {
		byte empty[] = new byte[512];
		for (int j = 0; j < 512; j++) {
			empty[j] = (byte) 0xE5;
		}
		System.arraycopy(empty, 0, sectors[0][0][0], 0, 512);
		System.arraycopy(empty, 0, sectors[0][0][1], 0, 512);
		System.arraycopy(empty, 0, sectors[0][0][2], 0, 512);
		System.arraycopy(empty, 0, sectors[0][0][3], 0, 512);
	}

	HashMap<String, File> dirContent = new HashMap<String, File>();
	List<String> dirContentKeys = new ArrayList<String>();

	private void listDir() {
		dirContent.clear();
		dirContentKeys.clear();
		int ii = 0;
		int noSect = 0;
		try {
			File folder = new File(path);
			if (folder.isDirectory()) {
				for (File sf : folder.listFiles()) {
					if (sf.isDirectory()) continue; // ignore directories
					String name = sf.getName().toUpperCase();
					if (name.contains(".")) {
						int point = name.indexOf(".");
						String filename = name.substring(0, point);
						filename = filename + "        ";
						filename = filename.substring(0, 8);
						String extension = name.substring(point + 1,
								name.length());
						extension = extension + "   ";
						extension = extension.substring(0, 3);

						name = filename + extension;
					} else {
						name = name + "        " + "   ";
						name = name.substring(0, 8 + 3);
					}
					System.out.println("#DIR : "+name);
					// FIXME Dangerous : all files are renamed at begin of process, into Amstrad CPC filename style.
					// This will not be corrected on this "experimental" version :P
					File fSuperAmstradName = new File(path + "\\" + name);
					sf.renameTo(fSuperAmstradName);
					dirContent.put(name, fSuperAmstradName);
					dirContentKeys.add(name);

				}

			}
			resetSectorContent();
			byte line[] = new byte[32];
			for (int j = 0; j < 32; j++) {
				line[j] = 0x00;
			}

			byte empty[] = new byte[512];
			for (int j = 0; j < 512; j++) {
				empty[j] = (byte) 0xE5;
			}

			int i = 0;
			// file content pointer (from DIRSTRUCT)
			byte writeNoSect = 0x02; // +1 do a step about 1024Ko ?
			// file content
			int writeH = 0;
			int writeC = 0;
			int writeR = 4;
			
			boolean teaForTwo=false; 

			for (String name : dirContentKeys) {
				noSect = i / 16; // 0x1800 / 0x20
				if (noSect >= 4) {
					throw new MagicCPCDiscImageException(MagicCPCDiscImageException.FILE_STRUCTDIR_TOO_BIG);
				}
				ii = i % 16;
				byte[] sectData = sectors[0][0][noSect];

					File f = dirContent.get(name);
					long fileLength = f.length();
					System.out.println("DIR : "+name);
					
					// SAMPLE 180.DSK : fileSize=x49 (73), displayed : 
					// 16bits listing "sectors" : 02 03 04 05 06 07 08 09 0A 0B 00 00 00 00 00 00
					// So One full DIREntry equals 10Kb 
					// A full DIREntry has size x80 (128)
					// 16Kb=> 128
					// 1Kb   => 8 increments
					// 1025b => 8 increments
					//  128b => 1 increment
					try  {
						byte[] selectedFileContent = new byte[512];
						FileInputStream fis = new FileInputStream(f);
						while (fis.read(selectedFileContent) > 0) {
							System.arraycopy(selectedFileContent, 0,
									sectors[writeH][writeC][writeR], 0, 512);
							teaForTwo=!teaForTwo;
							writeR++;
							if (writeR >= SECTS) {
								writeR = 0;
								writeC++;
								if (writeC >= CYLS) {
									break;
								}
							}
							
							System.arraycopy(empty, 0, selectedFileContent, 0, 512);
						}
						if (teaForTwo) {
							teaForTwo=!teaForTwo;
							writeR++;
							if (writeR >= 9) {
								writeR = 0;
								writeC++;
								if (writeC >= CYLS) {
									break;
								}
							}
						}
						fis.close();
					} catch (Exception e) {
						e.printStackTrace();
					}
					// a file of 64Kb filled with x"20" (space chat) : 65536bytes

					long m = fileLength / (16 * 1024); // number of this file DIREntry
					long mm = fileLength % (16 * 1024); // data referenced by last DIREntry (if not a full data DIREntry)
					if (mm>0) {
						m++; // last block does include the last not full-sized packet.
					}
					for (int n = 0; n < m; n++) {

						noSect = (i + n) / 16;
						
						if (noSect >= 4) {
							throw new MagicCPCDiscImageException(MagicCPCDiscImageException.FILE_STRUCTDIR_TOO_BIG);
						}
						
						ii = (i + n) % 16;
						sectData = sectors[0][0][noSect];

						System.arraycopy(line, 0, sectData, ii * 0x20, 32);
						System.arraycopy(name.getBytes(), 0, sectData,
								ii * 0x20 + 1, 8 + 3);

						if (n == m - 1 && mm > 0) {
							// mm : byte count in the last sector pointed.
							long mmm=mm/128;
							long mmmm=mm%128;
							if (mmmm>0) {
								mmm++; // last small bytes are also on it.
							}
							// FIXME (for bigger disk : 
							sectData[ii * 0x20 + 1 + 8 + 3 + 3] = (byte) mmm;
							// mm : byte count in the last sector pointed.
							long nnn=mm/1024;
							long nnnn=mm%1024;
							if (nnnn>0) {
								nnn++; // last small bytes are also on it.
							}
							for (int k = 0; k < nnn; k++) {
								// <16KB of different sector IDs
								sectData[ii * 0x20 + 16 + k] = writeNoSect; // 0x02;
								writeNoSect++;
							}
						} else {
							sectData[ii * 0x20 + 1 + 8 + 3 + 3] = (byte) 0x80;
							for (int k = 1 + 8 + 3 + 4; k < 32; k++) {
								// 16KB of different sector IDs
								sectData[ii * 0x20 + k] = writeNoSect;
								writeNoSect++;
							}

						}
						// "first add"
						int c=n/32;
						int cc=n%32;
						sectData[(ii) * 0x20 + 1 + 8 + 3 + 2] = (byte) c;
						sectData[(ii) * 0x20 + 1 + 8 + 3] = (byte) cc;
					}
					i += m;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		scanNames = doScanAllNamesFromSectors();
	}

	protected static int sectorSize(int n) {
		return n > 5 ? 0x1800 : 0x80 << n;
	}

	protected int getSectorIndex(int[][] ids, int c, int h, int r, int n) {
		for (int i = 0; i < ids.length; i++) {
			int[] id = ids[i];
			if (id[0] == c && id[1] == h && id[2] == r && id[3] == n)
				return i;
		}
		return -1;
	}

	public byte[] readSector(int cylinder, int head, int c, int h, int r, int n) {
		head &= headMask;
		byte[] result = null;
		if (cylinder <= lastCylinder) {
			int index = getSectorIndex(ids[head][cylinder], c, h, r, n);
			if (index != -1)
				result = sectors[head][cylinder][index];
		}
		return result;
	}

	public int[] getSectorID(int cylinder, int head, int index) {
		return ids[head & headMask][cylinder][index];
	}

	public int getSectorCount(int cylinder, int head) {
		return cylinder > lastCylinder ? 0
				: ids[head & headMask][cylinder].length;
	}

	boolean isData = false;
	boolean isBank = true;
	List<String> scanNames = new ArrayList<String>();
	List<Byte> buffer = new ArrayList<Byte>();
	int cursorWrite = 0;
	
	Integer cylinderBank=null;
	Integer headBank=null;
	Integer indexBank=null;
	
	@Override
	public void notifyWriteSector(byte data, int cylinder, int head, int c,
			int h, int r, int n) {
		head &= headMask;
		if (cylinder <= lastCylinder) {
			int index = getSectorIndex(ids[head][cylinder], c, h, r, n);
			if (index != -1) {

				if (head == 0 && cylinder == 0 && index < 4) {
					if (isData) {
						cursorWrite = 0;
						isData = false;
					}
					if (cursorWrite == 512 - 1) {
						doScanNames(true, head,cylinder,index);
					}
				} else {
					// writing on data area
					if (!isData) {
						cursorWrite = 0;
						isData = true;
					}
					
					if (cursorWrite==0) {
						if (cylinderBank==null) {
							// START OF DATA BLOCK.
							cylinderBank=cylinder;
							headBank=head;
							indexBank=index;
							isBank=true;
						} else if (cylinderBank==cylinder && headBank==head && indexBank==index) {
							// second time you are writing on this block, certainly a headFile write operation.
							isBank=false; // stopping to Bank
						}
					}
					
					if (isBank) {
						// Writing pure DATA, before writing complete filename in DirStruct
						buffer.add(data);
					} else {
						// Writing file HEAD, before writing complete filename in DirStruct (big binary files, in more than 1 DIRStruct page)
						if (buffer.size()>0) {
							buffer.add(cursorWrite, data);
							if (cursorWrite == 512 - 1) {
								// called just one time for a file of 32Kb, seems really good here.
								for (int i=0;i<512;i++) {
									buffer.remove(512);
								}
							}
							cylinderBank=null; // leaving fileHead (for normal txt, no pb : always isBank=true)
						} else {
							// what ?
							cylinderBank=null;
						}
					}
				}
			}

		}
		cursorWrite++;
		if (cursorWrite == 512) {
			cursorWrite = 0;
		}
	}

	/**
	 * @return list of all filenames in DIRStruct sectors, flat.
	 */
	private List<String> doScanAllNamesFromSectors() {
		List<String> flatScanNames= new ArrayList<String>();
		for (int index=0;index<4;index++) {
			byte[] result = sectors[0][0][index];
			System.out.println("\n#DIRSTRUCT SCAN "+index);
			for (int i = 0; i < result.length / 32; i++) {
				byte[] filename = new byte[8 + 3];
				System.arraycopy(result, i * 0x20 + 1, filename, 0,
						8 + 3);
				// toto.$$$ : temporary file.
				if (result[i * 0x20] != -27
						&& filename[8 + 3 - 1] != -27 && filename[8 + 3 - 1] != '$') {
					String s = "";
					for (int j = 0; j < 8 + 3; j++) {
						s += (char) filename[j];
					}
					flatScanNames.add(s);
				}
			}
		}
		return flatScanNames;
	}
	
	/**
	 * Before a read or after a write on DIRStruct sectors (index<4)
	 */
	private void doScanNames(boolean isWrite, int head, int cylinder, int index) {
		List<String> newScanNames = doScanAllNamesFromSectors();
		try {
			String filename = checkNewFile(scanNames,newScanNames);
			if (filename!=null) {
				System.out.println("FILE ADDED (isWrite="+isWrite+") : " + filename);
				File f = new File(path + "\\" + filename);
				
				try {
					byte[] buff = new byte[512];
					// do append file
					FileOutputStream fos = new FileOutputStream(
							f, true);
					for (int b = 0; b < buffer.size(); b++) {
						buff[b%512] = buffer.get(b);
						if (b%512==511) {
							fos.write(buff);
						} else if (b == buffer.size()-1) {
							fos.write(buff,0,b%512+1);
						}
					}
					fos.flush();
					fos.close();
					buffer.clear();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			// new file or else nothing : that's ok to turn this page.
			scanNames=newScanNames;
			return;
		} catch (BadScanNameMomentException e) {
			// DIRStruct is not yet aligned (turning page)
			// or else a not implemented yet operation (rename/erase)
			System.out.println("Something but a new file by here");
		}
		
		try {
			List<String> filenames = checkRenameFile(scanNames,newScanNames);
			if (filenames != null) {
				System.out.println("Renaming file "+filenames.get(0) + " into "+filenames.get(1));
				File f = new File(path + "\\" + filenames.get(0));
				File f2 = new File(path + "\\" + filenames.get(1));
				f.renameTo(f2);
			}
			// renamed file or else nothing : that's ok to turn this page.
			scanNames=newScanNames;
			return;
		} catch (BadScanNameMomentException e) {
			// DIRStruct is not yet aligned (turning page)
			// or else a not implemented yet operation (rename/erase)
			System.out.println("Something but a new file/a rename file by here");
		}
		
		try {
			String filename = checkEraseFile(scanNames,newScanNames);
			if (filename != null) {
				System.out.println("Erasing file "+filename);
				File f = new File(path + "\\" + filename);
				f.delete();
			}
			// renamed file or else nothing : that's ok to turn this page.
			scanNames=newScanNames;
			return;
		} catch (BadScanNameMomentException e) {
			// DIRStruct is not yet aligned (turning page)
			// or else a not implemented yet operation (rename/erase)
			System.out.println("Something but a new file/a rename file/an erase file by here : DIRStruct is not yet aligned, do just continue.");
		}
		// DIRStruct is not yet aligned (turning page), cannot deduce operation, do just continue.
	}
	/**
	 * Erasing a file... does disappear one filename only.
	 * @return null : nothing has changed
	 * @return filename : a file has been erased
	 * @throw BadScanNameMomentException : something else happen (page turn, or erase or rename)
	 */
	private String checkEraseFile(List<String> scanNames,
			List<String> newScanNames) throws BadScanNameMomentException {
		HashMap<String,Integer> fileEntryCounts = new HashMap<String,Integer>();
		for (String name : scanNames) {
			if (fileEntryCounts.containsKey(name)) {
				int n = fileEntryCounts.get(name)-1;
				fileEntryCounts.put(name, n);
			} else {
				fileEntryCounts.put(name, -1);
			}
		}
		for (String name : newScanNames) {
			if (fileEntryCounts.containsKey(name)) {
				int n =fileEntryCounts.get(name)+1;
				fileEntryCounts.put(name, n);
			} else {
				fileEntryCounts.put(name, +1);
			}
		}
		String candidate=null;
		boolean candidateHasProblem=false;
		for (String name : fileEntryCounts.keySet()) {
			if (fileEntryCounts.get(name)<0) {
				if (!candidateHasProblem) {
					candidate=name;
					candidateHasProblem=true;
				} else {
					// second problem
					throw new BadScanNameMomentException();
				}
			} else if (fileEntryCounts.get(name)>0) {
				// an new file or a rename happened...
				throw new BadScanNameMomentException();
			}
		}
		return candidate;
	}
	/**
	 * Renaming a file... does disappear and appear one filename only on the same DIRStruct entry.
	 * @return null : nothing has changed
	 * @return filename : a file has been renamed
	 * @throw BadScanNameMomentException : something else happen (page turn, or erase or rename)
	 */
	private List<String> checkRenameFile(List<String> scanNames,
			List<String> newScanNames) throws BadScanNameMomentException {
		HashMap<String,Integer> fileEntryCounts = new HashMap<String,Integer>();
		for (String name : scanNames) {
			if (fileEntryCounts.containsKey(name)) {
				int n = fileEntryCounts.get(name)-1;
				fileEntryCounts.put(name, n);
			} else {
				fileEntryCounts.put(name, -1);
			}
		}
		for (String name : newScanNames) {
			if (fileEntryCounts.containsKey(name)) {
				int n =fileEntryCounts.get(name)+1;
				fileEntryCounts.put(name, n);
			} else {
				fileEntryCounts.put(name, +1);
			}
		}
		String candidateFrom=null;
		String candidateTo=null;
		boolean candidateFromHasProblem=false;
		boolean candidateToHasProblem=false;
		for (String name : fileEntryCounts.keySet()) {
			if (fileEntryCounts.get(name)>0) {
				if (!candidateToHasProblem) {
					candidateTo=name;
					candidateToHasProblem=true;
				} else {
					// second problem
					throw new BadScanNameMomentException();
				}
			} else if (fileEntryCounts.get(name)<0) {
				if (!candidateFromHasProblem) {
					candidateFrom=name;
					candidateFromHasProblem=true;
				} else {
					// second problem
					throw new BadScanNameMomentException();
				}
			}
		}
		if (candidateFromHasProblem!=candidateToHasProblem) {
			throw new BadScanNameMomentException();
		} else if (candidateFrom == null && candidateTo == null) {
			return null;
		}
		List<String> candidates=new ArrayList<String>();
		candidates.add(candidateFrom);
		candidates.add(candidateTo);
		return candidates;
	}
	/**
	 * @return null : nothing has changed
	 * @return filename : a new file or a new file append
	 * @throw BadScanNameMomentException : something else happen (page turn, or erase or rename)
	 */
	private String checkNewFile(List<String> scanNames, List<String> newScanNames) throws BadScanNameMomentException {
		HashMap<String,Integer> fileEntryCounts = new HashMap<String,Integer>();
		for (String name : scanNames) {
			if (fileEntryCounts.containsKey(name)) {
				int n = fileEntryCounts.get(name)-1;
				fileEntryCounts.put(name, n);
			} else {
				fileEntryCounts.put(name, -1);
			}
		}
		for (String name : newScanNames) {
			if (fileEntryCounts.containsKey(name)) {
				int n =fileEntryCounts.get(name)+1;
				fileEntryCounts.put(name, n);
			} else {
				fileEntryCounts.put(name, +1);
			}
		}
		String candidate=null;
		boolean candidateHasProblem=false;
		for (String name : fileEntryCounts.keySet()) {
			if (fileEntryCounts.get(name)>0) {
				if (!candidateHasProblem) {
					candidate=name;
					candidateHasProblem=true;
				} else {
					// second problem
					throw new BadScanNameMomentException();
				}
			} else if (fileEntryCounts.get(name)<0) {
				// an erasure or a rename happened...
				throw new BadScanNameMomentException();
			}
		}
		return candidate;
	}
	
	@Override
	public void notifyReadSector(boolean beginOfSector, int cylinder, int head, int c, int h, int r,
			int n) {
		head &= headMask;
		if (cylinder <= lastCylinder) {
			int index = getSectorIndex(ids[head][cylinder], c, h, r, n);
			if (index != -1) {
				if (head == 0 && cylinder==0 && beginOfSector && index <4) {
					doScanNames(true, head,cylinder,index);
				}
			}
		}
		
	}

}
