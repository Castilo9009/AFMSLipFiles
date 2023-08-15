import sys
import re

if __name__ == "__main__":
    fname = sys.argv[1]

    with open(fname, 'r') as f:
        header = {v: i for i,v in enumerate(f.readline().split('\t'))}
        print(header)

        kcs = [v[4:-1] for v in header if v[0:2] == "KC"]
        kcs.sort()

        for i,v in enumerate(kcs):
            print("(%i) %s" % (i+1, v))
        modelId = int(input("Which KC model? "))-1
        model = "KC (%s)" % (kcs[modelId])
        opp = "Opportunity (%s)" % (kcs[modelId])

        
        allStudents = set()
        allKCs = set()
        allProblems = set()

        row_ids = []
        stu = []
        qs = []
        opps = []
        ys = []
        pnames = []


        for line in f:
            data = line.split('\t')

            kcs = data[header[model]].split("~~")
            kcs = [kc for kc in kcs if kc != ""]

            if not kcs:
                continue
            qs.append(kcs)
            for kc in kcs:
                allKCs.add(kc)

            kcOpp = data[header[opp]].split("~~")
            kcOpp = [o for o in kcOpp if o != ""]
            opps.append(kcOpp)

            if data[header['First Attempt']] == "correct":
                ys.append("1")
            else:
                ys.append("0")

            student = data[header['Anon Student Id']]
            stu.append(student)
            allStudents.add(student)

            problem = data[header['Problem Name']] + "##" + data[header['Step Name']]
            #problem = data[header['Step Name']]
            pnames.append(problem)
            allProblems.add(problem)

            row_id = data[header['Row']]
            row_ids.append(row_id)

        allStudents = {v: i for i,v in enumerate(allStudents)}
        allKCs = {v: i for i,v in enumerate(allKCs)}

        print("Creating RID Matrix File...")
        with open("RIDmatrix.tdt", "w") as RIDout:
            RIDout.write("Row ID\n")
            RIDout.write("\n".join(row_ids))
        print("Done.")
        
        print("Creating Q Matrix File...")
        with open("Qmatrix.tdt", 'w') as Qout:
            Qout.write("\t".join([kc for kc in allKCs]) + "\n")
            for q in qs:
                Qrow = ["1" if kc in q else "0" for kc in allKCs]
                Qout.write("\t".join(Qrow) + "\n")
        print("Done.")

        print("Creating Opp Matrix File...")
        with open("Oppmatrix.tdt", 'w') as OPPout:
            OPPout.write("\t".join([kc for kc in allKCs]) + "\n")
            for i,q in enumerate(qs):
                Opprow = [str(int(opps[i][q.index(kc)])-1) if kc in q else "0" for kc in allKCs]

            #for i,v in enumerate(opps):
            #    row = ["0" for i in range(len(allKCs))]
            #    for k, kc in enumerate(qs[i]):
            #        row[allKCs[kc]] = str(int(v[k]))
                OPPout.write("\t".join(Opprow) + "\n")
            print("Done.")

        print("Creating S Matrix File...")
#        with open('Smatrix.mat', 'w') as Sout:
#            Sout.write("# Created by processDatashop.py\n")
#            Sout.write("# name: S\n")
#            Sout.write("# type: sparse matrix\n")
#            Sout.write("# nnz: " + str(len(stu)-1) + "\n")
#            Sout.write("# rows: " + str(len(stu)) + "\n")
#            Sout.write("# columns: " + str(len(allStudents)) + "\n")
#            output = []
#            for row, s in enumerate(stu):
#                output.append([str(row+1), str(allStudents[s]+1), '1'])
#            output.sort(key=lambda x: int(x[1]))
#            Sout.write('\n'.join([" ".join(o) for o in output]))

        with open("Smatrix.tdt", 'w') as Sout:

            Sout.write("\t".join([s for s in allStudents]) + "\n")
            for s in stu:
                Srow = ["1" if s == s2 else "0" for s2 in allStudents]
                Sout.write("\t".join(Srow) + "\n")
        print("Done.")

        print("Creating y Matrix File...")
        with open('ymatrix.tdt', 'w') as yout:
            yout.write("Correct\n")
            yout.write("\n".join(ys))
        print("Done.")

        print("Creating problem id Matrix File...")
        with open('pmatrix.tdt', 'w') as pout:
            pout.write("Problem ID\n")
            key = {v:i for i,v in enumerate(allProblems)}
            pid = [str(key[pname]) for pname in pnames]
            pout.write("\n".join(pid))
        print("Done.")




        

        
        
